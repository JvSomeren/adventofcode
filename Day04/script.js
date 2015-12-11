function findHash(secretKey, numZeroes) {
	var num = 0,
			hash = md5(secretKey + num);

	while(hash.slice(0, numZeroes) !== '000000'.slice(0, numZeroes)) {
		num++;
		hash = md5(secretKey + num);
	}

	return num;
}

var input = 'yzbqklnj';

document.getElementById('answer-part-one').innerHTML = findHash(input, 5) + ' was your secret hash';
document.getElementById('answer-part-two').innerHTML = findHash(input, 6) + ' was your secret hash';