INSERT INTO
    guestbook (name, email, message, created_at)
VALUES
    ($1, $2, $3, $4)
RETURNING
    *
