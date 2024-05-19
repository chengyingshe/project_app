<html>
<head>
    <meta charset="utf-8">
    <title></title>
</head>
<body>
<form method="post" action="" enctype="multipart/form-data">
    prob_id:<input type="text" name="prob_id"><br>
    <input type="submit"><br>

</form>
</body>
</html>

<?php
include "../setting.php";

$prob_id = $_POST['prob_id'];

try {
//    echo $prob_id;
    //创建PDO实例对象
    $conn = new PDO("mysql:dbname=$dbname;host=$servername;port=$port", $username, $password);
    //设置错误模式
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $sql = "delete from problist where prob_id='$prob_id'";
    $stmt = $conn->prepare($sql);
    $stmt->execute();

} catch (PDOException $e) {
    echo "failed";
}