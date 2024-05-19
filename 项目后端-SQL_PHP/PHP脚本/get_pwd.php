<?php

//连接MySQL数据库
$servername = "localhost";
$username = "root";
$password = "root";
$database = "projectdb";
$port = 3306;
$result = "";  //定义返回结果

try {
    $conn = new mysqli($servername, $username, $password, $database, $port);
    if ($conn->connect_error) {
        $result = "fail";  //数据库连接失败
    } else {
        $id = $_GET["id"];
        $sql = "select pwd from user where id=" . $id;
        $query = $conn->query($sql);
        if ($query->num_rows > 0) { //查询到数据时
            $result = $query->fetch_assoc()["pwd"];
        }
        //当未查询到数据时，$result=""
    }
} catch (HttpException $e) {
    $result = "fail";
    echo $e->getMessage();
}

echo $result;