<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="multipart/form-data">
    <title></title>
</head>
<body>
<form method="post" action="" enctype="multipart/form-data">
    prob_id:<input type="text" name="prob_id"><br>
    analyse:<input type="text" name="analyse"><br>
    solution:<input type="text" name="solution"><br>
    solve_state:<input type="text" name="solve_state"><br>
    solve_ddl:<input type="text" name="solve_ddl"><br>
    solve_image:<input type="file" name="solve_image"><br>
    <input type="submit"><br>
</form>
</body>
</html>

<?php
include "../setting.php";

$prob_id = $_POST['prob_id'];
$analyse = $_POST['analyse'];
$solution = $_POST['solution'];
$solve_state = $_POST['solve_state'];
$solve_ddl = $_POST['solve_ddl'];

$type = $_FILES['solve_image']['type'];
$name = $_FILES['solve_image']['name'];
$size = $_FILES['solve_image']['size'];
$error = $_FILES['solve_image']['error'];
$tmp_name = $_FILES['solve_image']['tmp_name'];
$f = null;
$sql1 = "";
try {
    //创建PDO实例对象
    $conn = new PDO("mysql:dbname=$dbname;host=$servername;port=$port", $username, $password);
    //设置错误模式
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    if ($size > 0) { //当有solve_image上传时
        $f = fopen($tmp_name, 'rb');
        $f = fread($f, $size);
        $sql1 = "update problist set solve_image=? where prob_id=?";
        $stmt1 = $conn->prepare($sql1);
        $stmt1->bindValue(1, $f);
        $stmt1->bindValue(2, $prob_id);
        $stmt1->execute();
    }
    if ($analyse) {
        $sql = "update text set analyse=? where prob_id=?";
        $stmt = $conn->prepare($sql);
        $stmt->bindValue(1, $analyse);
        $stmt->bindValue(2, $prob_id);
        $stmt->execute();
    }
    if ($solution) {
        $sql = "update text set solution=? where prob_id=?";
        $stmt = $conn->prepare($sql);
        $stmt->bindValue(1, $solution);
        $stmt->bindValue(2, $prob_id);
        $stmt->execute();
    }
    if ($solve_state) {
        $solve_state =(int)$solve_state;
        $sql = "update problist set solve_state=? where prob_id=?";
        $stmt = $conn->prepare($sql);
        $stmt->bindValue(1, $solve_state);
        $stmt->bindValue(2, $prob_id);
        $stmt->execute();
    }
    if ($solve_ddl) {
        $solve_ddl =(int)$solve_ddl;
        $sql = "update problist set solve_ddl=? where prob_id=?";
        $stmt = $conn->prepare($sql);
        $stmt->bindValue(1, $solve_ddl);
        $stmt->bindValue(2, $prob_id);
        $stmt->execute();
    }
    echo "success";
} catch (PDOException $e) {
    echo "failed";
}
