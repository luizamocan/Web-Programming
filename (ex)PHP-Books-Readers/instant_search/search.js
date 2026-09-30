
function searchReaders()
{
    let text =
        document.getElementById(
            "search"
        ).value;

    let xhr =
        new XMLHttpRequest();

    xhr.onreadystatechange =
    function()
    {
        if(xhr.readyState == 4
           &&
           xhr.status == 200)
        {
            let readers =
                xhr.responseText
                .trim()
                .split("\n");

            readers.sort();

            let html = "";

            for(let i = 0;
                i < readers.length;
                i++)
            {
                if(readers[i] != "")
                {
                    html +=
                        "<li>"
                        + readers[i]
                        + "</li>";
                }
            }

            document.getElementById(
                "results"
            ).innerHTML = html;
        }
    };

    xhr.open(
        "GET",
        "search_ajax.php?text="
        + encodeURIComponent(text),
        true
    );

    xhr.send();
}

