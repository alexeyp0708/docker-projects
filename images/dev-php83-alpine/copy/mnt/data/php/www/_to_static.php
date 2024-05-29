<?php 
$file=$_SERVER['DOCUMENT_ROOT'].'/'.$_SERVER['DOCUMENT_URI'];
 if (file_exists($file)){
    //$finfo = finfo_open(FILEINFO_MIME_TYPE); 
     
    //$type=finfo_file($finfo, $file);
    //finfo_close($finfo);
    $type = mime_content_type($file);
    if(substr($type,0,5)=="text/"){
        $types=[
            '.txt'=>'text/plain',
            '.js'=>"application/javascript",
            '.json'=>"application/json",
            '.jsonld'=>"application/ld+json",
            '.mjs'=>"text/javascript",
            '.csh'=>'application/x-csh',
            '.css'=>'text/css',
            '.csv'=>'text/csv',
            '.doc'=>'application/msword',
            '.docx'=>'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            '.html'=>'text/html',
            '.htm'=>'text/html',
            '.xhtml'=>'application/xhtml+xml',
            '.xml'=>'application/xml',
            '.xul'=>'application/vnd.mozilla.xul+xml',
            '.pdf'=>'application/pdf',
            '.ics'=>'text/calendar'
        ];
        $ext=null;
        
        preg_match ('~\\.[\w\d]+$~',$file,$ext);
        $type=$types[$ext[0]]??$type;
    }


    header("Content-Type: $type");
    readfile($file);
 } else {
    $_SERVER['SCRIPT_FILENAME']=$_SERVER['DOCUMENT_ROOT'].'/index.php';
    include $_SERVER['SCRIPT_FILENAME'];
 }
