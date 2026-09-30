
document.addEventListener("DOMContentLoaded", () => {
    
   
    const thumbnails = document.querySelectorAll(".thumbnails img");
    const bigImage = document.getElementById("bigImage");

 
    thumbnails.forEach(thumbnail => {
        
  
        thumbnail.addEventListener("mouseover", function() {
            if(thumbnail==thumbnails[thumbnails.length-1]) return;
            const largeImageSrc = this.getAttribute("data-large");
            bigImage.src = largeImageSrc;
        });

  
        thumbnail.addEventListener("mouseout", function() {
            bigImage.src = "";
        }); 
        
    });
});