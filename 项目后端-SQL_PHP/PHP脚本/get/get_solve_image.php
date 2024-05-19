<?php
include "../setting.php";

try {
    //创建PDO实例对象
    $conn = new PDO("mysql:dbname=$dbname;host=$servername;port=$port", $username, $password);
    //设置错误模式
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $prob_id = $_GET['prob_id'];

    $sql = "select solve_image from problist where prob_id=$prob_id";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $fetch = $stmt->fetch(PDO::FETCH_ASSOC);

    $result = $fetch['solve_image'];
    Header("Content-type:image/jpg");
    echo $result;
} catch (PDOException $e) {
}

