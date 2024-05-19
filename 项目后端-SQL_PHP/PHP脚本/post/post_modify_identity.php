<?php

include "../setting.php";
//通过post方法来修改user的信息，需要修改什么信息就传入什么信息

try {
    //创建PDO实例对象
    $conn = new PDO("mysql:dbname=$dbname;host=$servername;port=$port", $username, $password);
    //设置错误模式
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $identityArr = array('id' => $_POST['id'], 'pwd' => $_POST['pwd'], 'phone' => $_POST['phone'], 'name' => $_POST['name'], 'department' => $_POST['department'], 'gender' => $_POST['gender'], 'address' => $_POST['address']);
    $sql = "update user set ";
    foreach ($identityArr as $k => $v) {
        if ($v != null && $k != 'id') {
            echo "$k = $v<br>";
            $sql .= "$k='$v', ";
        }
    }
    $sql = trim($sql, ', ');
    $sql .= " where id={$identityArr['id']}";
    echo $sql;
    $stmt = $conn->prepare($sql);
    $stmt->execute();

} catch (PDOException $e) {
    $result = "failed";
}
