<?php

include "../setting.php";

$description = $_GET['description'];
$analyse = $_GET['analyse'];
$solution = $_GET['solution'];
$result = array();
try {
    //创建PDO实例对象
    $conn = new PDO("mysql:dbname=$dbname;host=$servername;port=$port", $username, $password);
    //设置错误模式
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $sql1 = "select prob_id from `text` where description like '%$description%'";
    $sql2 = "select prob_id from `text` where analyse like '%$analyse%'";
    $sql3 = "select prob_id from `text` where solution like '%$solution%'";
    if ($description) {//在description中匹配
        $stmt = $conn->prepare($sql1);
        $stmt->execute();
        $fetch = $stmt->fetchAll(PDO::FETCH_COLUMN);  //将返回的结果存储在数字index作为key的数组
        foreach ($fetch as $k=>$v) {
            $result[] = $v;
        }
    }
    if ($analyse) {//在description中匹配
        $stmt = $conn->prepare($sql2);
        $stmt->execute();
        $fetch = $stmt->fetchAll(PDO::FETCH_COLUMN);  //将返回的结果存储在数字index作为key的数组
        foreach ($fetch as $k=>$v) {
            if (!in_array($v, $result)) {
                $result[] = $v;
            }
        }
    }
    if ($solution) {//在description中匹配
        $stmt = $conn->prepare($sql3);
        $stmt->execute();
        $fetch = $stmt->fetchAll(PDO::FETCH_COLUMN);  //将返回的结果存储在数字index作为key的数组
        foreach ($fetch as $k=>$v) {
            if (!in_array($v, $result)) {
                $result[] = $v;
            }
        }
    }
    foreach ($result as $k=>$v) {
        echo $v."<br>";
    }

} catch (PDOException $e) {
    $result = "failed";
}
