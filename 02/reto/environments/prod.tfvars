environment = "prod"
region = "us-east-2"
list_recurses =[
    {
        name = "ec2-instance",
        price = 100
    },
    {
        name = "s3-bucket",
        price = 50
    },
    {
        name = "rds-database",
        price = 200
    }
]