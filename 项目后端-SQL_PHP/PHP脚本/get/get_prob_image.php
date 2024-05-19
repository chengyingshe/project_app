<?php
//读取MySQL数据库中表problist中的prob_image
include "../setting.php";

try {
    //创建PDO实例对象
    $conn = new PDO("mysql:dbname=$dbname;host=$servername;port=$port", $username, $password);
    //设置错误模式
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $prob_id = $_GET['prob_id'];

    $sql = "select prob_image from problist where prob_id=$prob_id";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $fetch = $stmt->fetch(PDO::FETCH_ASSOC);


    $data = $fetch['prob_image'];
    Header("Content-type:image/jpg");
    echo $data;

} catch (PDOException $e) {
    echo "failed";
}