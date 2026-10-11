/proc/num2hex(d as num, digits=0)
	var/result
	var/rem
	var/c
	result = ""
	d = abs(d)
	do
		rem = d % 16
		switch(rem)
			if(10)
				result = "A[result]"
			if(11)
				result = "B[result]"
			if(12)
				result = "C[result]"
			if(13)
				result = "D[result]"
			if(14)
				result = "E[result]"
			if(15)
				result = "F[result]"
			else
				c = num2text(rem)
				result = "[c][result]"
		d = round(d / 16)
	while(d)
	if(digits && isnum(digits))
		var/len = length(result)
		for(var/i = digits, i > len, i--)
			result = "0[result]"
	return result

/proc/hex2num(h)
	var/l
	var/sixteen
	var/result
	var/digit
	var/c
	if(findtext(h, "0x", 1, 3))
		h = copytext(h, 3)
	l = length(h)
	sixteen = 1
	result = 0
	digit = 0
	while(l)
		c = copytext(h, l)
		h = copytext(h, 1, l)
		l = length(h)
		switch(c)
			if("A", "a") digit = 10
			if("B", "b") digit = 11
			if("C", "c") digit = 12
			if("D", "d") digit = 13
			if("E", "e") digit = 14
			if("F", "f") digit = 15
			if("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
				digit = text2num(c)
			else
				return
		result += digit * sixteen
		sixteen *= 16
	return result

/proc/text2list(t)
	var/list/txtlist
	var/added
	txtlist = new()
	added = 0
	while(length(t) % 4)
		t += " "
		added += 1
	if(istext(t))
		var/l = length(t) / 2
		var/off1
		var/off2
		for(var/i = 0, i < l, i++)
			off1 = i * 2 + 1
			off2 = off1 + 1
			txtlist += text2ascii(copytext(t, off1, off2)) << 8 | text2ascii(copytext(t, off2, off2 + 1))
	if(added)
		txtlist += added
	return txtlist

/proc/list2text(l)
	var/txt
	var/added
	var/result
	txt = ""
	added = 0
	if(l:len % 2)
		added = l[l:len]
		l:len = l:len - 1
	for(var/i = l:len - 1, i > 0, i -= 2)
		result = ascii2text(l[i] >> 8 & 255) + ascii2text(l[i] & 255) + ascii2text(l[i + 1] >> 8 & 255) + ascii2text(l[i + 1] & 255)
		txt = "[result][txt]"
	if(added)
		txt = copytext(txt, 1, length(txt) + 1 - added)
	return txt

/proc/list2hex(l)
	var/hex
	hex = ""
	for(var/n in l)
		hex += num2hex(n, 4)
	return hex

/proc/hex2list(hex)
	var/len
	var/off
	var/hnum
	var/l[0]
	len = round(length(hex) / 4)
	for(var/i = 0, i < len, i++)
		off = i * 4
		hnum = copytext(hex, off + 1, off + 5)
		l += hex2num(hnum)
	return l

/proc/RC5_Encrypt(t, k)
	var/crypto/rc5/r
	r = new(t)
	r.Encrypt(k)
	return r.PrintHex()

/proc/RC5_Decrypt(t, k)
	var/crypto/rc5/r
	r = new /crypto/rc5(arglist(list(t, "type" = "hex")))
	r.Decrypt(k)
	return r.PrintText()

/crypto/New(t, type="text")
	SetData(t, type)

/crypto/proc/SetData(t, type="text")
	switch(type)
		if("list")
			if(istype(t, /list))
				var/lt = t
				data = lt:Copy()
		if("hex")
			if(istext(t))
				data = hex2list(t)
		else
			if(istext(t))
				data = text2list(t)

/crypto/proc/Encrypt(key, t=null, type="text")
	if(t)
		SetData(t, type)
	if(data.len)
		DoEncrypt(key)

/crypto/proc/Decrypt(key, t=null, type="hex")
	if(t)
		SetData(t, type)
	if(data.len)
		DoDecrypt(key)

/crypto/proc/DoEncrypt(key)

/crypto/proc/DoDecrypt(key)

/crypto/proc/PrintHex()
	if(data.len)
		return list2hex(data)

/crypto/proc/PrintList()
	if(data.len)
		return data

/crypto/proc/PrintText()
	if(data.len)
		return list2text(data)

/crypto/rc5/proc/rotl(x, y)
	return x << (y & 15) | x >> w - (y & 15)

/crypto/rc5/proc/rotr(x, y)
	return x >> (y & 15) | x << w - (y & 15)

/crypto/rc5/proc/Init(key)
	var/lt
	var/i
	var/u
	var/idx
	var/A
	var/B
	var/t3
	var/j
	lt = length(key)
	if(!lt)
		return 0
	if(lt % 2)
		key += " "
		lt++
	b = lt
	c = round(b / 2) + 1
	i = 0
	u = 2
	var/L[c]
	L[c] = 0
	for(i = b - 1, i != -1, i--)
		idx = round(i / u) + 1
		L[idx] = (L[idx] << 8) + text2ascii(copytext(key, i + 1, i + 2))
	S.len = t
	S[1] = P
	for(i = 1, i < t, i++)
		S[i + 1] = S[i] + 40503
	A = 0
	B = 0
	t3 = t * 3
	j = 0
	i = 0
	for(var/k = 0, k < t3, k++)
		S[i + 1] = rotl(S[i + 1] + A + B, 3)
		A = S[i + 1]
		L[j + 1] = rotl(L[j + 1] + A + B, A + B)
		B = L[j + 1]
		i = (i + 1) % t
		j = (j + 1) % c
	return 1

/crypto/rc5/DoEncrypt(key)
	var/lst
	var/a
	var/b
	if(!Init(key))
		return ""
	lst = data
	for(var/i = 1, i < lst:len, i += 2)
		a = lst[i]
		b = lst[i + 1]
		a = (a + S[1]) % 65536
		b = (b + S[2]) % 65536
		for(var/j = 1, j <= r, j++)
			a = (rotl(a ^ b, b) + S[j * 2 + 1]) % 65536
			b = (rotl(b ^ a, a) + S[j * 2 + 2]) % 65536
		if(i > 1)
			a ^= lst[i - 2]
			b ^= lst[i - 1]
		lst[i] = a
		lst[i + 1] = b

/crypto/rc5/DoDecrypt(key)
	var/offset
	var/cipher
	var/a
	var/b
	if(!Init(key))
		return ""
	offset = 1
	cipher = data
	if(cipher:len % 2)
		offset = 2
	for(var/i = cipher:len - offset, i > 0, i -= 2)
		a = cipher[i]
		b = cipher[i + 1]
		if(i > 1)
			a ^= cipher[i - 2]
			b ^= cipher[i - 1]
		for(var/j = r, j > 0, j--)
			b = rotr(b - S[j * 2 + 2], a) ^ a
			a = rotr(a - S[j * 2 + 1], b) ^ b
		a -= S[1]
		b -= S[2]
		if(a < 0) a = a + 65536
		if(b < 0) b = b + 65536
		cipher[i] = a
		cipher[i + 1] = b
