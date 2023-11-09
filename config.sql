-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS hojisvl_joyas;
USE hojisvl_joyas;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    ultima_sesion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    active TINYINT NOT NULL DEFAULT 1 -- 1 para activo, 0 para eliminado lógicamente
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    active TINYINT NOT NULL DEFAULT 1 -- 1 para activo, 0 para eliminado lógicamente
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    active TINYINT NOT NULL DEFAULT 1 -- 1 para activo, 0 para eliminado lógicamente
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE productos_categorias (
    id_producto INT NOT NULL,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE CASCADE,
    PRIMARY KEY (id_producto, id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    direccion_envio TEXT NOT NULL,
    active TINYINT NOT NULL DEFAULT 1, -- 1 para activo, 0 para eliminado lógicamente
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE detalles_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE carrito (
    id_carrito INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    active TINYINT NOT NULL DEFAULT 1, -- 1 para activo, 0 para eliminado lógicamente
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE carrito_detalle (
    id_carrito INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_carrito) REFERENCES carrito(id_carrito) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE,
    PRIMARY KEY (id_carrito, id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE reseñas (
    id_reseña INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_usuario INT NOT NULL,
    calificacion INT NOT NULL,
    comentario TEXT,
    fecha_reseña DATETIME DEFAULT CURRENT_TIMESTAMP,
    active TINYINT NOT NULL DEFAULT 1, -- 1 para activo, 0 para eliminado lógicamente
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE direcciones (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    direccion TEXT NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(20) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    active TINYINT NOT NULL DEFAULT 1, -- 1 para activo, 0 para eliminado lógicamente
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE imagenes_producto (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    active TINYINT NOT NULL DEFAULT 1, -- 1 para activo, 0 para eliminado lógicamente
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE descuentos_promociones (
    id_descuento INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    descuento DECIMAL(5, 2) NOT NULL, -- Porcentaje o cantidad fija
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    active TINYINT NOT NULL DEFAULT 1 -- 1 para activo, 0 para eliminado lógicamente
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE metodos_pago (
    id_metodo_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    detalles TEXT NOT NULL,
    active TINYINT NOT NULL DEFAULT 1, -- 1 para activo, 0 para eliminado lógicamente
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE historial_precios (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior DECIMAL(10, 2) NOT NULL,
    precio_nuevo DECIMAL(10, 2) NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE materiales (
    id_material INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    active TINYINT NOT NULL DEFAULT 1 -- 1 para activo, 0 para eliminado lógicamente
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE combos (
    id_combo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL, -- Precio del combo, que podría ser diferente a la suma de los productos individuales
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    active TINYINT NOT NULL DEFAULT 1 -- 1 para activo, 0 para eliminado lógicamente
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE detalles_combos (
    id_detalle_combo INT AUTO_INCREMENT PRIMARY KEY,
    id_combo INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL, -- Cantidad de cada producto en el combo
    FOREIGN KEY (id_combo) REFERENCES combos(id_combo) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índices para la tabla productos
CREATE INDEX idx_nombre ON productos(nombre);
CREATE INDEX idx_precio ON productos(precio);
CREATE INDEX idx_fecha_creacion ON productos(fecha_creacion);

-- Índices para la tabla pedidos
CREATE INDEX idx_estado ON pedidos(estado);
CREATE INDEX idx_fecha_pedido ON pedidos(fecha_pedido);

-- Índices para la tabla detalles_pedido
CREATE INDEX idx_cantidad ON detalles_pedido(cantidad);

-- Índices para la tabla reseñas
CREATE INDEX idx_calificacion ON reseñas(calificacion);
CREATE INDEX idx_fecha_reseña ON reseñas(fecha_reseña);

-- Índices para la tabla descuentos_promociones
CREATE INDEX idx_fecha_inicio ON descuentos_promociones(fecha_inicio);
CREATE INDEX idx_fecha_fin ON descuentos_promociones(fecha_fin);