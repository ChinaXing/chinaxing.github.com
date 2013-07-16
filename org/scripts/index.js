function hide_ppt(ele){
    var mask=ele;
    var container=ele.nextElementSibling;
    mask.style.display="none";
    container.style.display="none";
}
function show_ppt(ele){
    var mask=ele.parentElement.nextElementSibling;
    var container=mask.nextElementSibling;
    mask.style.display="block";
    container.style.display="block";
}
