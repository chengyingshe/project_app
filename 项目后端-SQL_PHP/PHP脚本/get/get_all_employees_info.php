<?php

//连接MySQL数据库
include "../setting.php";
$result = "";
try {
    //创建PDO实例对象
    $conn = new PDO("mysql:dbname=$dbname;host=$servername;port=$port", $username, $password);
    //设置错误模式
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $sql = "select * from user where department = 0 || department = 1";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);  //将返回的结果存储在数字index作为key的数组
    echo json_encode($data, JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) { //数据库连接失败
    $result = "fail";
}

echo $result;