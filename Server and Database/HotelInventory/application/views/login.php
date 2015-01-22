
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Signin for Hotel Inventory</title>
    
    <!-- Bootstrap core CSS -->
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom styles for this template -->
    <link rel="stylesheet" href="<?php echo base_url('/assets/css/signin.css');?>">
    
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

    <div class="container">
      <form class="form-signin" action="<?php echo site_url('/auth_manager/login');?>" method="post">
        <?php if(isset($error)): ?>
      <div class="alert alert-danger">
        <?php echo $error; ?>
      </div>
      <?php endif;?>
        <h2 class="form-signin-heading">Please login</h2>
        <input type="text" name="username" class="form-control" placeholder="Username" 
               required autofocus value="<?php $this->input->post('username');?>"/>
        <input type="password" name="password" class="form-control" placeholder="Password" 
               required value="<?php $this->input->post('password');?>" />
        <button class="btn btn-lg btn-primary btn-block" type="submit">Login</button>
      </form>
      
    </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
  </body>
</html>

