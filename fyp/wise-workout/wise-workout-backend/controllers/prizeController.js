const PrizeEntity = require('../entities/prizeEntity');

exports.getAllPrizes = async (req, res) => {
  try {
    const prizes = await PrizeEntity.getAll();
    res.status(200).json({ prizes });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
