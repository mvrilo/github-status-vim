function! GithubStatus()
  let s:res = webapi#http#get("https://status.github.com/api/last-message.json")
  let s:data = webapi#json#decode(s:res.content)
  echo "[Github Status] " . s:data.body . substitute(s:data.created_on, "\\(.*\\)T\\(.*\\)Z", " (updated on \\1 \\2)", "")
endfunction

command! GithubStatus call GithubStatus()
