<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="multipart/form-data">
    <title></title>
</head>
<body>
<form method="post" action="" enctype="multipart/form-data">
    prob_id:<input type="text" name="prob_id"><br>
    prob_image:<input type="file" name="prob_image"><br>
    description:<input type="text" name="description"><br>
    <input type="submit"><br>

</form>
</body>
</html>
<?php
include "../setting.php";
//通过post方法来修改user的信息，需要修改什么信息就传入什么信息

$prob_id = $_POST['prob_id'];
$description = $_POST['description'];
$type = $_FILES['prob_image']['type'];
$name = $_FILES['prob_image']['name'];
$size = $_FILES['prob_image']['size'];
$error = $_FILES['prob_image']['error'];
$tmp_name = $_FILES['prob_image']['tmp_name'];
//echo var_dump($_FILES);

try {
    //创建PDO实例对象
    $conn = new PDO("mysql:dbname=$dbname;host=$servername;port=$port", $username, $password);
    //设置错误模式
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $f = fopen($tmp_name, 'rb');
    $f = fread($f, $size);
    //先向表中新插入一个空行
    $sql1 = "insert into problist (prob_id, prob_image) values (:prob_id, :prob_image)";
    $stmt1 = $conn->prepare($sql1);
    $stmt1->bindParam(":prob_id", $prob_id);
    $stmt1->bindParam("prob_image", $prob_image);
    $prob_image = $f;
    $stmt1->execute();

    //更新表text中的数据
    $sql2 = "update text set description='$description' where prob_id='$prob_id'";
    $stmt2 = $conn->prepare($sql2);
    $stmt2->execute();

} catch (PDOException $e) {
    $result = "failed";
}
