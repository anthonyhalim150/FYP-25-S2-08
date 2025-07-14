const SpinModel = require('../models/spinModel');
const PrizeModel = require('../models/prizeModel');
const UserModel = require('../models/userModel');
const DailyQuestModel = require('../models/dailyQuestModel');

class SpinService {
  static async performSpin(userId, forceSpin = false) {
    const hasSpun = await SpinModel.hasSpunToday(userId);

    if (hasSpun && !forceSpin) throw new Error('ALREADY_SPUN');
    if (hasSpun && forceSpin) {
      const success = await SpinModel.deductTokens(userId, 50);
      if (!success) throw new Error('NOT_ENOUGH_TOKENS');
    }

    const prizes = await PrizeModel.getAll();
    if (prizes.length === 0) throw new Error('NO_PRIZES');

    const prize = prizes[Math.floor(Math.random() * prizes.length)];
    await SpinModel.logSpin(userId, prize);
    await SpinModel.applyPrize(userId, prize);
    const today = new Date().toISOString().slice(0,10);
    await DailyQuestModel.markQuestDone(userId, 'SPIN_LUCKY', today);

    const updatedTokens = await UserModel.getTokenCount(userId);

    return { prize, tokens: updatedTokens };
  }

  static async getSpinStatus(userId) {
    const lastSpin = await SpinModel.getLastSpin(userId);
    if (!lastSpin) return { hasSpunToday: false, nextFreeSpinAt: null };

    const now = new Date();
    const hasSpunToday = new Date(lastSpin.spun_at).toDateString() === now.toDateString();

    const nextFreeSpinAt = hasSpunToday
      ? new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1).toISOString()
      : null;

    return { hasSpunToday, nextFreeSpinAt };
  }
}

module.exports = SpinService;
