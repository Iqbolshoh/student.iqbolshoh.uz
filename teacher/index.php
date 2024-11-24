<?php

session_start();

if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] !== true) {
  header("Location: ../login/");
  exit;
}

if ($_SESSION['role'] != 'teacher') {
  header("Location: ../login/");
  exit;
}

include '../config.php';
$query = new Database();

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?php echo "Hello, {$_SESSION['role']}!"; ?></title>
  <?php include 'includes/css.php'; ?>
</head>

<body class="hold-transition sidebar-mini">
  <div class="wrapper">
    <?php include 'includes/navbar.php' ?>
    <div class="content-wrapper">

      <?php
      $arr = array(
        ["title" => "Home", "url" => "./"],
        ["title" => "Dashboard", "url" => "#"],
      );
      pagePath('Dashboard', $arr);
      ?>

      <section class="content">
        <div class="container-fluid">


          <?php echo "<h1>Hello, {$_SESSION['role']}!</h1>"; ?>

        </div>
      </section>
    </div>

    <?php include 'includes/footer.php'; ?>
  </div>

  <?php include 'includes/js.php' ?>
</body>

</html>