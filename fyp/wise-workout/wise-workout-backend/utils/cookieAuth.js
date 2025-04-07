exports.setCookie = (res, token) => {
    res.cookie('session', token, {
      httpOnly: true,
      secure: false, 
      sameSite: 'Lax',
      maxAge: 24 * 60 * 60 * 1000
    });
  };
  