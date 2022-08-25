import { CodeJar } from "https://medv.io/codejar/codejar.js";
import { compile } from "https://esm.sh/@danielx/civet@0.2.7";
import Prism from "https://cdn.skypack.dev/prismjs";

defaultCode = """sum := (a:number, b:number) => a + b
square := (a:number) => a * a

fun := -> 
  console.log "It's all fun and games till it breaks"

song := ["do", "re", "mi", "fa", "so"]

singers := {Jagger: "Rock", Elvis: "Roll"}

bitlist := [
  1, 0, 1
  0, 0, 1
  1, 1, 0
];


// hey jsx dudes... here
Component := () => <>{bitlist.map (x) => <p>x</p> }</>"""

editor = document.getElementById "editor"
preview = document.getElementById "preview"
errorBox = document.getElementById "error-box"
shareButton = document.getElementById "share-btn"

initialSourceCode = defaultCode

if window.location.hash
    withoutHash = window.location.hash.trim().replace(/^#/, "");
    initialSourceCode = atob(withoutHash);


highlight = (c) ->
    out = Prism.highlight(c.innerText,Prism.languages.javascript,"javascript");
    c.innerHTML = out

previewJar = CodeJar(preview, highlight,{
    tab: " ".repeat(2),
});

editorJar = CodeJar(editor, ->, {
    tab: " ".repeat(2),
});

onUpdate = (c) ->
    try
        browserCompile = compile(c);
        previewJar.updateCode(browserCompile);
        errorBox.innerText = "";        
    catch err
        errorBox.innerText = err.message;


editorJar.onUpdate onUpdate


editorJar.updateCode(initialSourceCode);
previewJar.updateCode compile initialSourceCode

onShare =  ->
   code = editorJar.toString();
   base64 = btoa(code);
   window.location.hash = base64;
   copyToClipboard(window.location.href);

