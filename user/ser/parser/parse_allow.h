/*
 * $Id: parse_allow.h,v 1.1 2004/08/13 21:46:27 janakj Exp $
 *
 * Copyright (c) 2004 Juha Heinanen
 *
 * This file is part of ser, a free SIP server.
 *
 * ser is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version
 *
 * For a license to use the ser software under conditions
 * other than those described here, or to purchase support for this
 * software, please contact iptel.org by e-mail at the following addresses:
 *    info@iptel.org
 *
 * ser is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program; if not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
#ifndef PARSE_ALLOW_H
#define PARSE_ALLOW_H
 
#include "hf.h"

 
/* 
 * casting macro for accessing RPID body 
 */
#define get_allow_methods(p_msg) (unsigned int)(p_msg)->allow->parsed)


/*
 * Parse Allow HF body
 */
int parse_allow(struct hdr_field* _h);


/*
 * Release memory
 */
void free_allow(unsigned int** _methods);

#endif /* PARSE_ALLOW_H */
