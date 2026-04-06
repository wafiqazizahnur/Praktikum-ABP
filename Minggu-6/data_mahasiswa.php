<!DOCTYPE html>
<html>
<head>
    <title>Latihan AJAX Pencarian Mahasiswa</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .hasil-box {
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            padding: 15px;
            width: 300px;
            margin-top: 15px;
            border-radius: 5px;
        }
        .hasil-box p { margin: 5px 0; }
        .label { font-weight: bold; display: inline-block; width: 80px; }
    </style>
</head>
<body>
    <h2>Pencarian Data Mahasiswa</h2>
    <div>
        <label>Masukkan NIM: </label>
        <input type="text" id="nim" placeholder="Ketikkan NIM Anda" />
        <button type="button" id="cari">Cari Data</button>
    </div>
    <p id="pesan_error" style="color: red;"></p>
    
    <div class="hasil-box">
        <p><span class="label">Nama</span> : <span id="nama">-</span></p>
        <p><span class="label">Jurusan</span> : <span id="jurusan">-</span></p>
        <p><span class="label">Email</span> : <span id="email">-</span></p>
    </div>

    <script>
        $(document).ready(function() {
            $("#cari").click(function() {
                var nim_cari = $("#nim").val();
                
                $("#pesan_error").html("");
                $("#nama").text("Mencari...");
                $("#jurusan").text("Mencari...");
                $("#email").text("Mencari...");

                $.ajax({
                    url: "get_data.php",
                    type: "POST",
                    data: { nim: nim_cari },
                    dataType: "json",
                    timeout: 5000,
                    success: function(result) {
                        $("#nama").text(result.nama);
                        $("#jurusan").text(result.jurusan);
                        $("#email").text(result.email);
                    },
                    error: function(xhr, status, error) {
                        $("#pesan_error").html("Terjadi kesalahan: " + error);
                        $("#nama, #jurusan, #email").text("-");
                    },
                    complete: function(xhr, status) {
                        console.log("Status pencarian AJAX: " + status);
                    }
                });
            });
        });
    </script>
</body>
</html>