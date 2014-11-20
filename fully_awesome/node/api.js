var application_root = __dirname,
    express = require("express");
//     h5bp = require('h5bp'),
//     path = require("path"),
//     compression = require("compression");

var app = express();


// Database
var DBWrapper = require('node-dbi').DBWrapper;
var config = require('./config');
var dbConnectionConfig = { host:config.db.host, user:config.db.username, password:config.db.password, database:config.db.database };

// Middleware
// var compression = require('compression');

// 
// app.use(h5bp({ root: __dirname + '/public' }));
// app.use(compression({
//   threshold: 512
// }))
// app.use(express.static(__dirname + '/public'));
// app.listen(3000);

app.get('/api', function (req, res) {
  res.send('imgurprocess API is running');
});

// Abuser add update

app.get('/api/abuser_add_update', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	var result_array;
	dbWrapper.connect();

    query_string = 'SELECT status_id, status_desc \
                      FROM abuser.usp_abuser_add_update( \
                       $$' + req.param("email") + '$$, \
                       $$' + req.param("pw") + '$$, 1);'
						 
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

// Band add update

app.get('/api/band_add_update', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	var result_array;
	dbWrapper.connect();

    query_string = 'SELECT status_id, status_desc \
                      FROM abuser.usp_band_add_update( \
                       $$' + req.param("email") + '$$, \
                       $$' + req.param("name") + '$$,  \
                       $$' + req.param("ban_email") + '$$, \
                       $$' + req.param("description") + '$$,1);'
						 
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

// Event add update

app.get('/api/event_add_update', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	var result_array;
	dbWrapper.connect();

    query_string = 'SELECT status_id, status_desc \
                      FROM abuser.usp_event_add_update( \
                       $$' + req.param("email") + '$$, \
                       $$' + req.param("name") + '$$,  \
                       $$' + req.param("description") + '$$,  \
                       $$' + req.param("start") + '$$,  \
                       $$' + req.param("end") + '$$,  \
                       ' + req.param("evt_id") + ', 1, \
                       $$' + req.param("band") + '$$, \
                       $$' + req.param("img") + '$$, \
                       $$' + req.param("img_type") + '$$);'
						 
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


// Login

app.get('/api/login', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	var result_array;
	dbWrapper.connect();

    query_string = 'SELECT status_id, status_desc \
                      FROM abuser._usp_abuser_pass_check( \
                       $$' + req.param("email") + '$$, \
                       $$' + req.param("pw") + '$$);'
						 
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


// Add Update User

app.get('/api/abuser_add_update', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	var result_array;
	dbWrapper.connect();

    query_string = 'SELECT status_id, status_desc \
                      FROM abuser.usp_abuser_add_update( \
                       $$' + req.param("email") + '$$, \
                       $$' + req.param("pw") + '$$);'
						 
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

// Add Update User

app.get('/api/event_display', function (req, res){
	var dbWrapper = new DBWrapper('pg', dbConnectionConfig);
	var result_array;
	dbWrapper.connect();

    query_string = 'SELECT evt_id, evt_name, evt_description, evt_start \
                      FROM event.usp_event_display(1::bigint,NULL::text);'
						 
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