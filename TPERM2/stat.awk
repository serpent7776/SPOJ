BEGIN {
	idx = 1;
}

NF == 1 {
	idx += 1;
	name = $1;
	names[idx] = name;
}

NF == 6 {
	stats[name, "r"] += $2;
	stats[name, "u"] += $4;
	stats[name, "s"] += $6;
	stats[name, "+"] += 1;
}

END {
	for (i in names) {
		name = names[i];
		count = stats[name, "+"];
		real = stats[name, "r"] / count;
		user = stats[name, "u"] / count;
		sys  = stats[name, "s"] / count;
		printf("%10s        %5.2f real        %5.2f user        %5.2f sys\n", name, real, user, sys);
	}
}
