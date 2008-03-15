

unit commontypes;


{****************************************************************
 ****************************************************************
 ***           This file belongs to PVIEW/PSKILL              ***
 ***        Copyright (c) 2001 by -=Assarbad [GoP]=-          ***
 ***       ____________                 ___________           ***
 ***      /\   ________\               /\   _____  \          ***
 ***     /  \  \       /    __________/  \  \    \  \         ***
 ***     \   \  \   __/___ /\   _____  \  \  \____\  \        ***
 ***      \   \  \ /\___  \  \  \    \  \  \   _______\       ***
 ***       \   \  \ /   \  \  \  \    \  \  \  \      /       ***
 ***        \   \  \_____\  \  \  \____\  \  \  \____/        ***
 ***         \   \___________\  \__________\  \__\            ***
 ***          \  /           /  /          /  /  /            ***
 ***           \/___________/ \/__________/ \/__/             ***
 ***                                                          ***
 ***  May the source be with you, stranger ... :-)            ***
 ***                                                          ***
 ***  Greets from -=Assarbad [GoP]=- ...                      ***
 ***  Special greets go 2 Nico, Casper, SA, Pizza, Navarion...***
 ***[for questions/proposals drop a mail to Assarbad@ePost.de]***
 *****************************************ASCII by Assa [GoP]****
 ****************************************************************}
interface
{$mode delphi}{$h+}
uses windows,
   sysutils;
TYPE
  TProcessrec = RECORD
    name: STRING;
    PID: DWORD;
  END;
  TProcessrecs = ARRAY OF TProcessrec;
implementation
FUNCTION MAKELANGID(PRI, SUB: WORD): integer;
BEGIN
  result := (SUB SHL 10) OR PRI;
END;

FUNCTION frmt(mformat: STRING; args: ARRAY OF POINTER): STRING;
VAR
  bla: pchar;
BEGIN
  getmem(bla, 1024 * 2 + 2);
  wvsprintf(bla, pchar(mformat), pchar(@args));
  result := STRING(bla);
  freemem(bla, 1024 * 2 + 2);
END;
end.
