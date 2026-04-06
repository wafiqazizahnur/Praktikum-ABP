<?php
$arrJurusan = [
    "Wafiq Nur Azizah" => "Teknik Informatika",
    "Afra" => "Teknik Informatika",
    "Loisa" => "Sistem Informasi"
];

echo $arrJurusan["Wafiq Nur Azizah"] . "<br>";
echo $arrJurusan['Loisa'] . "<br>";

$arrEmail = [];
$arrEmail["Wafiq Nur Azizah"] = "wafiq@example.com";
$arrEmail["Afra"] = "afra@example.com";
$arrEmail["Loisa"] = "loisa@example.com";

echo $arrEmail["Wafiq Nur Azizah"] . "<br>";
echo $arrEmail['Loisa'] . "<br>";
?>