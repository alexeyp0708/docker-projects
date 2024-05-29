<?php
    $url = $_SERVER['REQUEST_URI'];
    $url = parse_url($url);
    switch($url['path']){
        case '/' :
        case '/index.php' :
        case '/adminer' :
        case '/adminer/' :
        $path='/adminer/index.php';
        break;
        case '/editor':
        case '/editor/':
        $path='/editor/index.php';
        break;
    }
    if (empty($path)){
        header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
    } else {
        header("Location:$path".(!empty($url['query'])?'?'.$url['query']:""));
    }

