var express = require('express');
var router = express.Router();

var queryAsync = require('../mysql.js')

/* GET home page. */
router.get('/', async (req, res, next) => {
  try {
    let sql = 'SELECT d.* FROM post p LEFT JOIN data d ON d.post_id = p.post_id ORDER BY created_at DESC LIMIT 20;';
    posts = await queryAsync(sql);

    res.render('index', {
      req:req,
      title:"Rabbit",
      posts: posts
    });
  } catch (error) {
    console.log('SQL error', error);
    res.status(500).send('Something went wrong');
  }
});

router.get('/search', async (req, res) => {
  let opt = req.query.selectPicker;
  try {
    posts = await queryAsync('SELECT * FROM data p WHERE p.username LIKE ? OR p.header LIKE ? OR p.content LIKE ?', [`%${req.query.search_content}%`, `%${req.query.search_content}%`, `%${req.query.search_content}%`]);

    res.render('index', {
      posts: posts
    });
  } catch (error) {
    console.log('SQL error', error);
    res.status(500).send('Something went wrong');
  }
});

// signout
router.get('/signout', async (req, res, next) => {
  try {
    req.session.user = '';
    req.session.isAdmin = false;
    req.session.isLogin = false;
    res.redirect('/')
  } catch (error) {
    console.log('SQL error', error);
    res.status(500).send('Something went wrong');
  }
});

module.exports = router;