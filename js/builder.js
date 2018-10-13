const path = require('path')
const {execSync} = require('child_process')
console.log('BUILDING AND STARTING')

process.env.CFG_MENU_0_LABEL = 'hi people'
process.env.CFG_MENU_0_CHILDREN_0_LABEL = 'hi people1'
process.env.CFG_MENU_0_CHILDREN_0_CHILDREN_0_LABEL = 'hi people2'
process.env.CFG_MENU_1_LABEL = 'this is local'
process.env.CFG_MENU_2_LABEL = 'this is local2'

const path1 = path.join(process.cwd(), "build.sh")
const result1 = execSync(path1, {
    shell: true,
    stdio: [0, 1, 2],
    detached: false
})

const path2 = path.join(process.cwd(), "dist", "execute.sh")
const result2 = execSync(path2, {
    shell: true,
    stdio: [0, 1, 2],
    detached: false,
    cwd: path.join(process.cwd(), 'dist')
})

console.log(path1)
console.log(result1.toString())
console.log(path2)
console.log(result2.toString())
