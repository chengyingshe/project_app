<?php

include "../setting.php";
$result = "";
$id = $_GET['id'];  //获取get方法传过来的id

try {
    //创建PDO实例对象
    $conn = new PDO("mysql:dbname=$dbname;host=$servername;port=$port", $username, $password);
    //设置错误模式
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $sql = "select * from user where id=$id";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $fetch = $stmt->fetch(PDO::FETCH_ASSOC);  //将返回的结果存储在数字index作为key的数组

    if ($fetch) {
        foreach ($fetch as $k => $v) {
            if ($v == '0' || $v != null) {
                $result .= $k . "=" . $v . "<br>";
            } else { //当$v=null时
                $result .= $k . "=" . "null" . "<br>";
            }
        }
    }
} catch (PDOException $e) {
    $result = "failed";
}

echo $result;