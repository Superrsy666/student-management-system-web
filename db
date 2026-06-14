import os
from contextlib import contextmanager

import mysql.connector
from mysql.connector import pooling


DB_CONFIG = {
    "host": os.getenv("MYSQL_HOST", "127.0.0.1"),
    "port": int(os.getenv("MYSQL_PORT", "3306")),
    "user": os.getenv("MYSQL_USER", "root"),
    "password": os.getenv("MYSQL_PASSWORD", ""),
    "database": os.getenv("MYSQL_DATABASE", "student_management"),
    "charset": "utf8mb4",
    "use_unicode": True,
}

pool = None


def get_pool():
    global pool
    if pool is None:
        pool = pooling.MySQLConnectionPool(
            pool_name="student_management_pool",
            pool_size=5,
            **DB_CONFIG,
        )
    return pool


@contextmanager
def get_db():
    connection = get_pool().get_connection()
    try:
        yield connection
        connection.commit()
    except Exception:
        connection.rollback()
        raise
    finally:
        connection.close()


def fetch_one(query, params=None):
    with get_db() as connection:
        cursor = connection.cursor(dictionary=True)
        cursor.execute(query, params or ())
        row = cursor.fetchone()
        cursor.close()
        return row


def fetch_all(query, params=None):
    with get_db() as connection:
        cursor = connection.cursor(dictionary=True)
        cursor.execute(query, params or ())
        rows = cursor.fetchall()
        cursor.close()
        return rows


def execute(query, params=None):
    with get_db() as connection:
        cursor = connection.cursor()
        cursor.execute(query, params or ())
        lastrowid = cursor.lastrowid
        cursor.close()
        return lastrowid
