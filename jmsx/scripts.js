/* scripts.js */

  var romdir = 'rom';
  var romext = '.rom';
  var defrom = 'hero';
  var fstrom = 'basic';



  var hash  = location.hash.substr(1);
  var start = hash=='' ? defrom : hash;

  window.onload = function()
  {

    readdir(romdir, 'fill', 'rom');

    $('#helpt').onclick = function()
    {
      $('#helpt').style.display = 'none';
    }

    $('#helpb').onclick = function()
    {
      var dp = $('#helpt').style.display;
      $('#helpt').style.display = dp=='' || dp=='none' ? 'inline-block' : 'none';
    }

    $('#rom').onchange = function()
    {
      var rom = $('#rom').value;
      setApplet('emulator', rom);
      if (rom!=fstrom) location.hash = rom;
    }

    setApplet('emulator', start);

  }



  var grep = function(pattern, invert)
  // <http://gist.github.com/931857>
  {
    invert = invert || false;
    var ret = [];
    if (this.filter)
    {
      ret = this.filter(function(element)
      {
        var b = element.match(pattern);
        return b && !invert || invert && !b;
      });
    }
    else
    {
      for(var n in this)
      {
        var element = this[n];
        if (element.match && typeof element.match == 'function')
        {
          var b = element.match(pattern);
          if (b && !invert || invert && !b)
          {
            ret.push(element);
          }
        }
      }
    }
    return ret;
  }



  function readdir(dirname, action, element)
  {
    var dir = document.createElement('iframe');
    dir.src = dirname;
    dir.style.display = 'none';
    dir.onload = function()
    {
      var c = dir.contentWindow.document.body.innerHTML;
          c = c.replace(/<[^>]+>/g,'|');
          c = c.split('|');
          c.grep = grep;
          c = c.grep(romext);
      // <http://stackoverflow.com/questions/359788/how-to-execute-a-javascript-function-when-i-have-its-name-as-a-string>
      window[action](element, c);
    }
    document.body.appendChild(dir);
  }



  function fill(element,content_array)
  {
    var element = $('#'+element);
    element.innerHTML = '<option>' + fstrom + '</option>';
    for (i in content_array)
    {
      var re  = new RegExp(romext + '$');
      var rom = content_array[i].replace(re, '');
      element.innerHTML += '<option id="' + rom + '">' + rom + '</option>';
    }
    $('#'+start).selected = true;
  }



  function $(el)
  {
    var first = el.substr(0,1);
    return first=='#' ? document.getElementById(el.substr(1)) : document.getElementsByName(el)[0];
  }



  function setApplet(container_id, rom)
  {
    $('#cover').src = 'rom/' + rom + '.jpg';
    var emu = $('#'+container_id);
    emu.innerHTML = ''
                  + '<applet'
                  + ' archive = "jmsx-02.jar"'
                  + ' code    = "MsxEmu.class"'
                  + ' width   = "512"'
                  + ' height  = "384"'
                  + '>'
                  + '  <param name="rom" value="' + romdir + '/' + rom + romext + '" />'
                  + '</applet>'
                  ;
  }



/* EOF */
