<?php

//连接MySQL数据库
include "../setting.php";
$result = "";
try {
    //创建PDO实例对象
    $conn = new PDO("mysql:dbname=$dbname;host=$servername;port=$port", $username, $password);
    //设置错误模式
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $stmt = $conn->prepare("select count(*) as problist_num from problist");
    $stmt->execute();
    $fetch = $stmt->fetch(PDO::FETCH_ASSOC);
    $result = 'problist_num='.$fetch['problist_num']."<br>";

    $prob_id = $_GET['prob_id'];  //获取get方法传过来的id
    $sql = "select prob_taken_time, solve_state, solve_ddl,solve_person from problist where prob_id=$prob_id";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $fetch = $stmt->fetch(PDO::FETCH_ASSOC);  //将返回的结果存储在数字index作为key的数组

    if ($fetch) { //传回来的结果不为空时
        foreach ($fetch as $k => $v) {
            if ($v == '0' || $v != null) {
                $result .= $k . "=" . $v . "<br>";
            } else { //当$v=null时
                $result .= $k . "=" . "null" . "<br>";
            }
        }
    } else {
        $result = "";
    }
} catch (PDOException $e) { //数据库连接失败
    $result = "fail";
}

echo $result;