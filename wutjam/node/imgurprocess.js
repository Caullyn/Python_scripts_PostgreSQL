var application_root = __dirname,
    express = require("express"),
    path = require("path");

var app = express();

// Database
var DBWrapper = require('node-dbi').DBWrapper;
var config = require('./config');
var dbConnectionConfig = { host:config.db.host, user:config.db.username, password:config.db.password, database:config.db.database };

app.get('/api', function (req, res) {
  res.send('imgurprocess API is running');
});

// bets per day

app.get('/api/bpd', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	var result_array;
	dbWrapper.connect();

    query_string = 'SELECT 1" \
						 WHERE dpb_day >= $$' + req.param("startDate") + '$$ \
						   AND dpb_day <= $$' + req.param("endDate") + '$$ \
						 GROUP BY 1 \
						 ORDER BY 1';
						 
	dbWrapper.fetchAll(query_string, null, function (err, result) {
	  if (!err) {
		console.log(" %s", query_string);
		console.log( result)
	    res.header('Access-Control-Allow-Origin', "*")
		res.send(result );
	  } else {
		console.log("DB returned an error: %s", err);
		console.log(" %s", query_string);
	  }

	  dbWrapper.close(function (close_err) {
		if (close_err) {
		  console.log("Error while disconnecting: %s", close_err);
		}
	  });
	});
});

// players per day

app.get('/api/ppd', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	dbWrapper.connect();

	query_string = ' SELECT (EXTRACT(EPOCH FROM dpb_day)::bigint * 1000) as "0", SUM(dpb_player_count) AS "1" \
						  FROM day_player_bet \
						 WHERE dpb_day >= $$' + req.param("startDate") + '$$ \
						   AND dpb_day <= $$' + req.param("endDate") + '$$ \
						 GROUP BY (EXTRACT(EPOCH FROM dpb_day)::bigint * 1000) \
						 ORDER BY (EXTRACT(EPOCH FROM dpb_day)::bigint * 1000) ;'
						 
	dbWrapper.fetchAll(query_string, null, function (err, result) {
	  if (!err) {
		console.log(" %s", query_string);
	    res.header('Access-Control-Allow-Origin', "*")
		res.send(result );
	  } else {
		console.log("DB returned an error: %s", err);
	  }

	  dbWrapper.close(function (close_err) {
		if (close_err) {
		  console.log("Error while disconnecting: %s", close_err);
		}
	  });
	});
});

// languages per day

app.get('/api/dpl', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	dbWrapper.connect();

	dbWrapper.fetchAll('SELECT dpl_lang AS label, sum(dpl_player_count) AS data \
						  FROM day_player_lng \
						 WHERE dpl_day >= $$' + req.param("startDate") + '$$ \
						   AND dpl_day <= $$' + req.param("endDate") + '$$ \
						 GROUP BY dpl_lang \
						 ORDER BY dpl_lang;', null, function (err, result) {
	  if (!err) {
	    res.header('Access-Control-Allow-Origin', "*")
		res.send( JSON.stringify(result) );
		console.log(Date.now())
	  } else {
		console.log("DB returned an error: %s", err);
	  }

	  dbWrapper.close(function (close_err) {
		if (close_err) {
		  console.log("Error while disconnecting: %s", close_err);
		}
	  });
	});
});

// devices per day

app.get('/api/dpd', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	dbWrapper.connect();

	dbWrapper.fetchAll('SELECT dpd_device AS label, SUM(dpd_player_count) AS data \
						  FROM day_player_dev \
						 WHERE dpd_day >= $$' + req.param("startDate") + '$$ \
						   AND dpd_day <= $$' + req.param("endDate") + '$$ \
						 GROUP BY dpd_device \
						 ORDER BY dpd_device;', null, function (err, result) {
	  if (!err) {
	    res.header('Access-Control-Allow-Origin', "*")
		res.send( JSON.stringify(result) );
	  } else {
		console.log("DB returned an error: %s", err);
	  }

	  dbWrapper.close(function (close_err) {
		if (close_err) {
		  console.log("Error while disconnecting: %s", close_err);
		}
	  });
	});
});


// game per day

app.get('/api/dpg', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	dbWrapper.connect();

	dbWrapper.fetchAll('SELECT dpg_game AS label, SUM(dpg_player_count) AS data \
						  FROM day_player_gam \
						 WHERE dpg_day >= $$' + req.param("startDate") + '$$ \
						   AND dpg_day <= $$' + req.param("endDate") + '$$ \
						 GROUP BY dpg_game \
						 ORDER BY dpg_game;', null, function (err, result) {
	  if (!err) {
	    res.header('Access-Control-Allow-Origin', "*")
		res.send( JSON.stringify(result) );
	  } else {
		console.log("DB returned an error: %s", err);
	  }

	  dbWrapper.close(function (close_err) {
		if (close_err) {
		  console.log("Error while disconnecting: %s", close_err);
		}
	  });
	});
});

// player loyalty

app.get('/api/pll', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	dbWrapper.connect();

	dbWrapper.fetchAll('SELECT pll_desc AS label, pll_count AS data \
						  FROM player_loyalty \
						 WHERE pll_count > 0 \
						 ORDER BY pll_id;', null, function (err, result) {
	  if (!err) {
	    res.header('Access-Control-Allow-Origin', "*")
		res.send( JSON.stringify(result) );
	  } else {
		console.log("DB returned an error: %s", err);
	  }

	  dbWrapper.close(function (close_err) {
		if (close_err) {
		  console.log("Error while disconnecting: %s", close_err);
		}
	  });
	});
});

// Bets and release dates

app.get('/api/brd', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	dbWrapper.connect();

	dbWrapper.fetchAll('SELECT (EXTRACT(EPOCH FROM brd_day)::bigint * 1000)  AS "0", brd_bet_count AS "1" \
						  FROM bet_release_date \
						 ORDER BY brd_day;', null, function (err, result) {
	  if (!err) {
	    console.log( result )
	    res.header('Access-Control-Allow-Origin', "*")
		res.send( result );
	  } else {
		console.log("DB returned an error: %s", err);
	  }

	  dbWrapper.close(function (close_err) {
		if (close_err) {
		  console.log("Error while disconnecting: %s", close_err);
		}
	  });
	});
});

app.get('/api/grd', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	dbWrapper.connect();

	dbWrapper.fetchAll('SELECT (EXTRACT(EPOCH FROM grd_day)::bigint * 1000)  AS "0", COUNT(grd_games_released) AS "1" \
						  FROM game_release_date \
						 GROUP BY (EXTRACT(EPOCH FROM grd_day)::bigint * 1000)\
						 ORDER BY (EXTRACT(EPOCH FROM grd_day)::bigint * 1000);', null, function (err, result) {
	  if (!err) {
	    res.header('Access-Control-Allow-Origin', "*")
	    console.log( result )
		res.send( result );
	  } else {
		console.log("DB returned an error: %s", err);
	  }

	  dbWrapper.close(function (close_err) {
		if (close_err) {
		  console.log("Error while disconnecting: %s", close_err);
		}
	  });
	});
});


// start and end dates 

app.get('/api/dates', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	dbWrapper.connect();

	dbWrapper.fetchAll('SELECT now() as today, (now() - $$2 weeks$$::interval) + $$1 day$$::interval as startDate;', null, function (err, result) {
	  if (!err) {
	    res.header('Access-Control-Allow-Origin', "*")
		res.send( JSON.stringify(result) );
	  } else {
		console.log("DB returned an error: %s", err);
	  }

	  dbWrapper.close(function (close_err) {
		if (close_err) {
		  console.log("Error while disconnecting: %s", close_err);
		}
	  });
	});
});

// Launch server

app.listen(4242);