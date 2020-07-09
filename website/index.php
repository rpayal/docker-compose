<html>
    <head>
        <title>My Shop</title>
    </head>

    <body>
        <h1>Welcome to my shop</h1>
        <h2>
            <?php
                $resp = file_get_contents('http://product-service/hello');
                echo json_decode($resp);
            ?>
        </h2>
        <ul>
            <?php
                $json=file_get_contents('http://product-service');
                $obj=json_decode($json);

                $products=$obj->products;
                foreach ($products as $product) {
                    echo "<li>$product</li>";
                }
            ?>
        </ul>
    </body>
</html>

