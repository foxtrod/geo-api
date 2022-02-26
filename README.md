# geo-api
API to manage geo data by ip or url

# Running application via docker
Copy and set environment variables with:  
```cp .env.example .env```

Build and run application with:
1. ```docker-compose up --build```
2. ```docker-compose run web rails db:create db:migrate```

# API docs
### 1. Fetch geodata by ip or url
```GET: /geolocations?query=http://example.com```

```GET: /geolocations?query=192.168.0.1```

```query``` parameter accepts URL and IP formats

Response examples:
```
{
    "id": 1,
    "ip": "123.123.123.121",
    "query": "123.123.123.121",
    "country": "China",
    "city": "Beijing",
    "zip": "China",
    "latitude": "39.91175842285156",
    "longitude": "116.37922668457031",
    "created_at": "2022-02-26T10:30:44.625Z",
    "updated_at": "2022-02-26T10:30:44.625Z"
}
```

```
{
    "errors": {"detail": "Not Found"}
}
```

### 2. Delete geodata by ip or url
```DELETE: /geolocations?query=http://example.com```

```DELETE: /geolocations?query=192.168.0.1```

```query``` parameter accepts URL and IP formats

Response examples: 
```
"ok"
```
```
{
    "error": "not found"
}
```

# Things to improve
1. Provide more detailed responses by applying [JSON API standard](https://jsonapi.org/) 
2. Improve test coverage by adding model & controller specs
3. Make API endpoints secure by restricting access via JWT
