<?php
$data_mahasiswa = [
    "2311102270" => [
        "nama" => "Wafiq Nur Azizah",
        "jurusan" => "Teknik Informatika",
        "email" => "wafiq@example.com"
    ],
    "2311102280" => [
        "nama" => "Afra",
        "jurusan" => "Teknik Informatika",
        "email" => "afra@example.com"
    ],
    "2311102290" => [
        "nama" => "Loisa",
        "jurusan" => "Sistem Informasi",
        "email" => "loisa@example.com"
    ]
];

if (isset($_POST['nim'])) {
    $nim = $_POST['nim'];
    if (array_key_exists($nim, $data_mahasiswa)) {
        echo json_encode($data_mahasiswa[$nim]);
    } else {
        echo json_encode([
            "nama" => "Tidak ditemukan",
            "jurusan" => "-",
            "email" => "-"
        ]);
    }
}
?>