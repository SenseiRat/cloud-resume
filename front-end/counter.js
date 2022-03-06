async function getVisitCount () {
    // TODO: Change this to automatically update the URL properly
    const Url = 'https://3em2cgu9vi.execute-api.us-east-1.amazonaws.com/resume-api'

    fetch(Url)
    .then(data=>{return data.json()})
    .then(data=>{document.getElementById("counter").innerHTML = "Number of visitors: " + data['Visitors']})
}

getVisitCount()
