async function getVisitCount () {
    const Url = 'https://3em2cgu9vi.execute-api.us-east-1.amazonaws.com/resume-api'

    fetch(Url)
    .then(data=>{return data.json()})
    .then(res=>{console.log(res)})
}

var visitor_count = getVisitCount()
console.log(visitor_count)