# vim: noet

test_compile:
	set -e; for m in `find lib -name '*.pm'`; do perl -Ilib -c $$m; done

test: test_compile
	prove t/*.t

install:
	# modules
	mkdir -p -m 0755 $(DESTDIR)/usr/share/perl5/
	cp -r lib/* $(DESTDIR)/usr/share/perl5/
	# configs
	cp -r etc $(DESTDIR)/

clean:
	rm -rf tfiles

.PHONY: test install clean
