
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Hotel Inventory - Admin</title>
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="<?php echo base_url('/assets/css/sticky-footer.css');?>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?php foreach($css_files as $file): ?>
	<link type="text/css" rel="stylesheet" href="<?php echo $file; ?>" />
    <?php endforeach; ?>
    <?php foreach($js_files as $file): ?>
    <script src="<?php echo $file; ?>"></script>
    <?php endforeach; ?>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js" type="text/javascript"></script>
  </head>
  <body>
    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="<?php echo site_url();?>">
            Hotel Inventory
          </a>
        </div>
        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <?php if(Auth::has_roles(ROLE_ADMIN)):?>
            <li><a href="<?php echo site_url('/manager/users');?>">Users</a></li>
            <?php endif; ?>
            <li><a href="<?php echo site_url('/manager/hotels');?>">Hotels</a></li>
            <li><a href="<?php echo site_url('/manager/storages');?>">Storages</a></li>
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                Items <b class="caret"></b>
              </a>
              <ul class="dropdown-menu">
                <li>
                  <a href="<?php echo site_url('/manager/items');?>">
                    Items
                  </a>
                </li>
                <li>
                  <a href="<?php echo site_url('/manager/item_types');?>">
                    Item Types
                  </a>
                </li>
              </ul>
            </li>
            <li><a href="<?php echo site_url('/manager/stocks');?>">Stocks</a></li>
          </ul>
          <?php if(Auth::is_auth()): ?>
          <form class="navbar-form navbar-right" method="post" action="<?php echo site_url('/auth_manager/logout'); ?>">
            <span style="color:white;"><strong>Login as: </strong>
              <?php echo Auth::user_attr('username'); ?>
              &nbsp;
            </span>
            <button type="submit" class="btn btn-success">Logout</button>
          </form>
          <?php else: ?>
          <form class="navbar-form navbar-right" method="post" action="<?php echo site_url('/auth_manager/login'); ?>">
            <div class="form-group">
              <input type="text" name="email" placeholder="Email" 
                class="form-control" value="<?php echo $email; ?>">
            </div>
            <div class="form-group">
              <input type="password" name="password" placeholder="Password" 
                class="form-control" value="<?php echo $password; ?>">
            </div>
            <button type="submit" class="btn btn-success">Login</button>
          </form>
          <?php endif; ?>
        </div><!--/.navbar-collapse -->
      </div>
    </div>
    <!-- Wrap all page content here -->
    <div id="wrap">
      <div class="container">
        <div style="margin-top:60px;">
          <h3><?php echo $_GET['title']; ?></h3>
          <hr />
          <?php echo $output; ?>
        </div>  
      </div> <!-- container -->
    </div> <!-- wrap -->
    <br /><br />
  <div id="footer">
    <div class="container">
      <p style="text-align:center;">
        <br />
        <small>
          Created by Green Team as the part of CS 4153 (Mobile Application Development) project.
        </small>
      </p>
    </div>
  </div>
</body>
</html>
