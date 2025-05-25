const spinEntity = require('../entities/spinEntity');

exports.spin = async (req, res) => {
  const userId = req.user?.id;
  if (!userId) return res.status(401).json({ message: 'Unauthorized' });

  const usingCoins = req.query.force === 'true';
  const hasSpun = await spinEntity.hasSpunToday(userId);

  if (hasSpun && !usingCoins) {
    return res.status(403).json({ message: 'Already spun today' });
  }

  if (hasSpun && usingCoins) {
    const success = await spinEntity.deductCoins(userId, 50);
    if (!success) {
      return res.status(403).json({ message: 'Not enough coins to re-spin' });
    }
  }

  const prize = spinEntity.getRandomPrize();
  await spinEntity.logSpin(userId, prize);
  await spinEntity.applyPrize(userId, prize);

  res.json({ prize });
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
