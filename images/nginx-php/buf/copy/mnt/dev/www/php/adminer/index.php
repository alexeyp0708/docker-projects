<?php
    $url = $_SERVER['REQUEST_URI'];
    $url = parse_url($url);
    switch($url['path']){
        case '/' :
        case '/adminer' :
        case '/adminer/' :
        $path='vendor/vrana/adminer/adminer';
        break;
        case '/editor':
        case '/editor/':
        $path='vendor/vrana/adminer/editor';
        break;
    }
    header("Location:/$path/index.php".(!empty($url['query'])?'?'.$url['query']:""));
