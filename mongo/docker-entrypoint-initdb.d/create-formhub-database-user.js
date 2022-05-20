db.createUser({
    user: "kobo",
    pwd: "insecure-mongo-kobo-dev",
    roles: [{role: "dbOwner", db: "formhub"}]
})
