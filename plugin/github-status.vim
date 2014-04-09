if exists('g:github_status') && g:github_status
  finish
endif
let g:github_status = 1

let s:url = "https://status.github.com/api/last-message.json"

function! GithubStatus()
  if has('python')
python << EOF
import vim, urllib, json, datetime
res = urllib.urlopen(vim.eval('s:url')).read()
data = json.loads(res)
when = datetime.datetime.strptime(data['created_on'], "%Y-%m-%dT%H:%M:%SZ").strftime("(updated on %Y/%m/%d %H:%M:%S)")
vim.command("echomsg '[Github Status] %s %s'" % (data['body'], when))
EOF
    return
  end

  if globpath(&rtp, 'autoload/webapi/http.vim') != ''
    let s:res = webapi#http#get(s:url)
    let s:data = webapi#json#decode(s:res.content)
    echo "[Github Status] " . s:data.body . substitute(s:data.created_on, "\\(.*\\)T\\(.*\\)Z", " (updated on \\1 \\2)", "")
    return
  endif

  echohl ErrorMsg | echomsg "GithubStatus: need Python or 'webapi' (https://github.com/mattn/webapi-vim)"
endfunction

command! GithubStatus call GithubStatus()
