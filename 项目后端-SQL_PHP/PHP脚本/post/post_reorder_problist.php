<?php
include "../setting.php";

try {
    //创建PDO实例对象
    $conn = new PDO("mysql:dbname=$dbname;host=$servername;port=$port", $username, $password);
    //设置错误模式
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $stmt = $conn->prepare("call order_problist_after_delete()");
    $stmt->execute();
    echo "success";
} catch (PDOException $e) {
    echo "failed";
}