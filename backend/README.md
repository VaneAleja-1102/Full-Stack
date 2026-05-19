# backend

necesitan configurar el config.ts en local dentro de la carpeta src, con la siguiente estructura:

export const CONFIG = {
    db: process.env.DB_CONNECTION || 'direccion de su base de datos',
    db_test: process.env.DB_CONNECTION_TEST || 'direccion de la base de datos test',
    app: {
        // Puerto en el que escucha el servidor HTTP
        port: process.env.PORT || 3000
    },
    jwt_key: process.env.JWT_KEY || 'secreto de su firmador de tokens',
}