function filterEvents()
{
    let threshold =
        document.getElementById(
            "threshold"
        ).value;

    let rows =
        document
        .getElementById(
            "eventsTable"
        )
        .rows;

    for(let i = 1;
        i < rows.length;
        i++)
    {
        let remaining =
            parseInt(

                rows[i]
                .getElementsByClassName(
                    "remaining"
                )[0]
                .innerHTML

            );

        if(
            threshold == ""
            ||
            remaining > threshold
          )
        {
            rows[i]
            .style.display = "";
        }
        else
        {
            rows[i]
            .style.display =
                "none";
        }
    }
}