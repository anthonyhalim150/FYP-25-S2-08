const spinEntity = require('../entities/spinEntity');
const PrizeEntity = require('../entities/prizeEntity');
const UserEntity = require('../entities/userEntity');

exports.spin = async (req, res) => {
  const userId = req.user?.id;
  if (!userId) return res.status(401).json({ message: 'Unauthorized' });

  const usingTokens = req.query.force === 'true';
  const hasSpun = await spinEntity.hasSpunToday(userId);

  if (hasSpun && !usingTokens) {
    return res.status(403).json({ message: 'Already spun today' });
  }

  if (hasSpun && usingTokens) {
    const success = await spinEntity.deductTokens(userId, 50);
    if (!success) {
      return res.status(403).json({ message: 'Not enough tokens to re-spin' });
    }
  }

  const prizes = await PrizeEntity.getAll();
  if (prizes.length === 0) {
    return res.status(500).json({ message: 'No prizes configured' });
  }

  const randomIndex = Math.floor(Math.random() * prizes.length);
  const prize = prizes[randomIndex];

  await spinEntity.logSpin(userId, prize);
  await spinEntity.applyPrize(userId, prize);

  const updatedTokens = await UserEntity.getTokenCount(userId);

  res.json({ prize, tokens: updatedTokens });
};

exports.getSpinStatus = async (req, res) => {
  const userId = req.user?.id;
  if (!userId) return res.status(401).json({ message: 'Unauthorized' });

  const lastSpin = await spinEntity.getLastSpin(userId);
  if (!lastSpin) {
    return res.json({ hasSpunToday: false });
  }

  const lastSpinDate = new Date(lastSpin.spun_at);
  const now = new Date();
  const hasSpunToday = lastSpinDate.toDateString() === now.toDateString();

  const nextFreeSpinAt = hasSpunToday
    ? new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1)
    : null;

  res.json({
    hasSpunToday,
    nextFreeSpinAt: nextFreeSpinAt?.toISOString() ?? null,
  });
};
