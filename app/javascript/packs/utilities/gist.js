window.loadGists = loadGists

$(startLoadingGists())

function startLoadingGists() {
    loadGists()
    return $(document).on('turbolinks:load', loadGists)
}

function loadGists() {
    return $('.gist').each(function() {
        return loadGist($(this))
    })
}

function loadGist($gist) {
    let callbackName, script
    callbackName = 'c' + Math.random().toString(36).substring(7)
    window[callbackName] = function(gistData) {
        let html
        delete window[callbackName];
        html = '<link rel="stylesheet" href="' + encodeURI(gistData.stylesheet) + '"></link>'
        html += gistData.div
        $gist.html(html)
        return script.parentNode.removeChild(script)
    }
    script = document.createElement('script')
    script.setAttribute('src', [
        $gist.data('src'), $.param({
            callback: callbackName,
            file: $gist.data('file') || ''
        })
    ].join('?'))
    return document.body.appendChild(script)
}