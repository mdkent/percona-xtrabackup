# Makefile to build XtraBackup for Percona Server and different versions of MySQL
#
# Syntax:
# make [5.1|5.5|plugin|xtradb|xtradb55]
#
# Default is xtradb - to build XtraBackup for Percona Server 5.1
# xtradb55 - Xtrabackup for Percona Server 5.5
# 5.1 - XtraBackup for MySQL versions 5.1.* with builtin InnoDB
# plugin - XtraBackup for MySQL versions 5.1.* with InnoDB plugin
# 5.5 - XtraBackup for MySQL versions 5.5.*	

LIBS += -lpthread
DEFS = -DUNIV_LINUX -DMYSQL_SERVER

CFLAGS += -DXTRABACKUP_VERSION=\"$(XTRABACKUP_VERSION)\" -pedantic -Wall -Wundef -Wshadow  -fdiagnostics-show-option  -fno-strict-aliasing -Wno-strict-aliasing -Wextra -Wformat -Wno-format-nonliteral -Wno-format-security -Wno-long-long  -Wmissing-declarations  -Wno-redundant-decls --std=gnu99

ifneq ($(DEBUG),)
CFLAGS += -DXB_DEBUG=1
endif

TARGET=xtrabackup
PREFIX=/usr
BIN_DIR=$(PREFIX)/bin

COMMON_INC = -I. -I libarchive/libarchive -I quicklz
XTRABACKUPOBJS = xtrabackup.o stream.o local.o compress.o buffer.o \
	xbstream_write.o \
	quicklz/quicklz.o
XBSTREAMOBJS = xbstream.o xbstream_write.o xbstream_read.o

LIBARCHIVE_A = libarchive/libarchive/libarchive.a

default: xtradb

# XtraBackup for MySQL 5.1
5.1: INC = $(COMMON_INC) $(addprefix -isystem$(MYSQL_ROOT_DIR)/, \
	include storage/innobase/include)
5.1: INNODBOBJS = $(addprefix $(MYSQL_ROOT_DIR)/storage/innobase/libinnobase_a-, \
	btr0btr.o btr0cur.o btr0pcur.o \
	btr0sea.o buf0buf.o buf0flu.o buf0lru.o buf0rea.o data0data.o \
	data0type.o dict0boot.o dict0crea.o dict0dict.o dict0load.o dict0mem.o \
	dyn0dyn.o eval0eval.o eval0proc.o fil0fil.o fsp0fsp.o fut0fut.o \
	fut0lst.o ha0ha.o hash0hash.o ibuf0ibuf.o lock0iter.o lock0lock.o \
	log0log.o log0recv.o mach0data.o mem0mem.o mem0pool.o mtr0log.o \
	mtr0mtr.o os0file.o os0proc.o os0sync.o os0thread.o page0cur.o \
	page0page.o lexyy.o pars0grm.o pars0opt.o pars0pars.o pars0sym.o \
	que0que.o read0read.o rem0cmp.o rem0rec.o row0ins.o row0mysql.o \
	row0purge.o row0row.o row0sel.o row0uins.o row0umod.o row0undo.o \
	row0upd.o row0vers.o srv0que.o srv0srv.o srv0start.o sync0arr.o \
	sync0rw.o sync0sync.o thr0loc.o trx0purge.o trx0rec.o trx0roll.o \
	trx0rseg.o trx0sys.o trx0trx.o trx0undo.o usr0sess.o ut0byte.o \
	ut0dbg.o ut0list.o ut0mem.o ut0rnd.o ut0ut.o ut0vec.o ut0wqueue.o)
5.1: MYSQLOBJS= $(addprefix $(MYSQL_ROOT_DIR)/, mysys/libmysys.a  \
	strings/libmystrings.a zlib/.libs/libzlt.a dbug/libdbug.a)
5.1: TARGET := xtrabackup_51
5.1: $(TARGET) xbstream

# XtraBackup for MySQL with InnoDB Plugin
plugin: INC = $(COMMON_INC) $(addprefix -I$(MYSQL_ROOT_DIR)/, \
	include storage/innodb_plugin/include)
plugin: INNODBOBJS = $(addprefix \
	$(MYSQL_ROOT_DIR)/storage/innodb_plugin/ha_innodb_plugin_la-, \
	btr0btr.o btr0cur.o btr0pcur.o btr0sea.o buf0buddy.o buf0buf.o \
	buf0flu.o buf0lru.o buf0rea.o data0data.o data0type.o dict0boot.o \
	dict0crea.o dict0dict.o dict0load.o dict0mem.o dyn0dyn.o eval0eval.o \
	eval0proc.o fil0fil.o fsp0fsp.o fut0fut.o fut0lst.o ha0ha.o \
	ha0storage.o hash0hash.o ibuf0ibuf.o lock0iter.o lock0lock.o log0log.o \
	log0recv.o mach0data.o mem0mem.o mem0pool.o mtr0log.o mtr0mtr.o \
	os0file.o os0proc.o os0sync.o os0thread.o page0cur.o page0page.o \
	page0zip.o lexyy.o pars0grm.o pars0opt.o pars0pars.o pars0sym.o \
	que0que.o read0read.o rem0cmp.o rem0rec.o row0ext.o row0ins.o \
	row0merge.o row0mysql.o row0purge.o row0row.o row0sel.o row0uins.o \
	row0umod.o row0undo.o row0upd.o row0vers.o srv0que.o srv0srv.o \
	srv0start.o sync0arr.o sync0rw.o sync0sync.o thr0loc.o trx0purge.o \
	trx0rec.o trx0roll.o trx0rseg.o trx0sys.o trx0trx.o trx0undo.o \
	usr0sess.o ut0byte.o ut0dbg.o ut0list.o ut0mem.o ut0rnd.o ut0ut.o \
	ut0vec.o ut0wqueue.o ut0rbt.o)

plugin: MYSQLOBJS = $(addprefix $(MYSQL_ROOT_DIR)/, mysys/libmysys.a \
	strings/libmystrings.a zlib/.libs/libzlt.a dbug/libdbug.a)
plugin: TARGET := xtrabackup_plugin
plugin: $(TARGET) xbstream

# XtraBackup for MySQL 5.5
5.5: INC = $(COMMON_INC) $(addprefix -isystem$(MYSQL_ROOT_DIR)/, \
	include storage/innobase/include)
5.5: INNODBOBJS = $(MYSQL_ROOT_DIR)/storage/innobase/libinnobase.a

ifeq "$(wildcard $(MYSQL_ROOT_DIR)/zlib/.libs/libzlt.a)" ""
xtradb55: LIBZ= -lz
else
xtradb55: LIBZ= $(MYSQL_ROOT_DIR)/zlib/.libs/libzlt.a
endif

5.5: MYSQLOBJS = $(addprefix $(MYSQL_ROOT_DIR)/, \
	mysys/libmysys.a strings/libstrings.a zlib/libzlib.a dbug/libdbug.a)
ifeq ($(shell uname -s),Linux)
5.5: LIBS += -laio
endif
5.5: TARGET := xtrabackup_innodb55
# In CMake server builds it is important to build with exactly the same preprocessor flags
# as were used to build InnoDB
5.5: DEFS = $(shell grep C_DEFINES \
	$(MYSQL_ROOT_DIR)/storage/innobase/CMakeFiles/innobase.dir/flags.make | \
	sed -e 's/C_DEFINES = //')
5.5: $(TARGET) xbstream

# XtraBackup for XtraDB 
xtradb: INC = $(COMMON_INC) $(addprefix -isystem$(MYSQL_ROOT_DIR)/, \
	include storage/innodb_plugin/include)
xtradb: INNODBOBJS = $(addprefix \
	$(MYSQL_ROOT_DIR)/storage/innodb_plugin/libinnobase_a-, \
	btr0btr.o btr0cur.o btr0pcur.o \
	btr0sea.o buf0buddy.o buf0buf.o \
	buf0flu.o buf0lru.o buf0rea.o \
	data0data.o data0type.o dict0boot.o \
	dict0crea.o dict0dict.o dict0load.o \
	dict0mem.o dyn0dyn.o eval0eval.o \
	eval0proc.o fil0fil.o fsp0fsp.o \
	fut0fut.o fut0lst.o ha0ha.o \
	ha0storage.o hash0hash.o ibuf0ibuf.o \
	lock0iter.o lock0lock.o log0log.o \
	log0recv.o mach0data.o mem0mem.o \
	mem0pool.o mtr0log.o mtr0mtr.o \
	os0file.o os0proc.o os0sync.o \
	os0thread.o page0cur.o page0page.o \
	page0zip.o lexyy.o pars0grm.o \
	pars0opt.o pars0pars.o pars0sym.o \
	que0que.o read0read.o rem0cmp.o \
	rem0rec.o row0ext.o row0ins.o \
	row0merge.o row0mysql.o row0purge.o \
	row0row.o row0sel.o row0uins.o \
	row0umod.o row0undo.o row0upd.o \
	row0vers.o srv0que.o srv0srv.o \
	srv0start.o sync0arr.o sync0rw.o \
	sync0sync.o thr0loc.o trx0purge.o \
	trx0rec.o trx0roll.o trx0rseg.o \
	trx0sys.o trx0trx.o trx0undo.o \
	usr0sess.o ut0byte.o ut0dbg.o \
	ut0list.o ut0mem.o ut0rnd.o \
	ut0ut.o ut0vec.o ut0wqueue.o \
	ut0rbt.o)
xtradb: MYSQLOBJS = $(addprefix $(MYSQL_ROOT_DIR)/, mysys/libmysys.a \
	strings/libmystrings.a zlib/.libs/libzlt.a dbug/libdbug.a)
xtradb: DEFS += -DXTRADB_BASED 
xtradb: TARGET := xtrabackup 
xtradb: $(TARGET) xbstream

# XtraBackup for XtraDB 5.5
xtradb55: INC = $(COMMON_INC) $(addprefix -isystem$(MYSQL_ROOT_DIR)/, \
	include storage/innobase/include)
xtradb55: INNODBOBJS = $(MYSQL_ROOT_DIR)/storage/innobase/libinnobase.a
ifeq ($(shell uname -s),Linux)
xtradb55: LIBS += -laio
endif

ifeq "$(wildcard $(MYSQL_ROOT_DIR)/zlib/.libs/libzlt.a)" ""
xtradb55: LIBZ= -lz
else
xtradb55: LIBZ= $(MYSQL_ROOT_DIR)/zlib/.libs/libzlt.a
endif

xtradb55: MYSQLOBJS = $(addprefix $(MYSQL_ROOT_DIR)/, \
	mysys/libmysys.a strings/libstrings.a zlib/libzlib.a dbug/libdbug.a)
# In CMake server builds it is important to build with exactly the same 
# preprocessor flags as were used to build InnoDB
xtradb55: DEFS = $(shell grep C_DEFINES \
	$(MYSQL_ROOT_DIR)/storage/innobase/CMakeFiles/innobase.dir/flags.make | \
	sed -e 's/C_DEFINES = //')
xtradb55: DEFS += -DXTRADB_BASED -DXTRADB55
xtradb55: TARGET := xtrabackup_55
xtradb55: $(TARGET) xbstream

$(XTRABACKUPOBJS): %.o: %.c
	$(CC) $(CFLAGS) $(INC) $(DEFS) -c $< -o $@

xbstream.o xbstream_read.o: %.o: %.c
	$(CC) $(CFLAGS) $(INC) $(DEFS) -c $< -o $@

xbstream: $(XBSTREAMOBJS) $(MYSQLOBJS) local.o
	$(CC) $(CFLAGS) $^ $(INC) $(MYSQLOBJS) $(LIBS) -o $@

xtrabackup.o: xtrabackup.c xb_regex.h

$(TARGET): $(XTRABACKUPOBJS) $(INNODBOBJS) $(MYSQLOBJS) $(LIBARCHIVE_A)
	$(CC) $(CFLAGS) $(XTRABACKUPOBJS) $(INNODBOBJS) $(MYSQLOBJS) $(LIBS) \
	$(LIBARCHIVE_A) -o $(TARGET)

clean:
	rm -f $(XTRABACKUPOBJS) $(XBSTREAMOBJS) xtrabackup xtrabackup_* 
